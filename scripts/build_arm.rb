#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "json"
require "yaml"

ROOT = File.expand_path("..", __dir__)

def duration(value)
  match = value.to_s.match(/\A(\d+)([mhd])\z/)
  raise "Unsupported duration #{value.inspect}" unless match

  number, unit = match.captures
  { "m" => "PT#{number}M", "h" => "PT#{number}H", "d" => "P#{number}D" }.fetch(unit)
end

def operator(value)
  {
    "gt" => "GreaterThan",
    "gte" => "GreaterThanOrEqual",
    "lt" => "LessThan",
    "lte" => "LessThanOrEqual",
    "eq" => "Equal",
    "ne" => "NotEqual"
  }.fetch(value.to_s) { raise "Unsupported trigger operator #{value.inspect}" }
end

def load_rule(path)
  YAML.safe_load(File.read(path), [], [], false)
rescue ArgumentError
  YAML.safe_load(File.read(path), permitted_classes: [], permitted_symbols: [], aliases: false)
end

rule_paths = Dir.glob(File.join(ROOT, "Detections", "**", "*.yaml")).sort
abort "No analytics rules found" if rule_paths.empty?

resources = rule_paths.map do |path|
  rule = load_rule(path)
  {
    "id" => "[concat(resourceId('Microsoft.OperationalInsights/workspaces/providers', parameters('workspaceName'), 'Microsoft.SecurityInsights'), '/alertRules/#{rule.fetch('id')}')]",
    "type" => "Microsoft.OperationalInsights/workspaces/providers/alertRules",
    "apiVersion" => "2025-09-01",
    "name" => "[concat(parameters('workspaceName'), '/Microsoft.SecurityInsights/', '#{rule.fetch('id')}')]",
    "kind" => "Scheduled",
    "properties" => {
      "displayName" => rule.fetch("name"),
      "description" => rule.fetch("description"),
      "enabled" => "[parameters('enabled')]",
      "severity" => rule.fetch("severity"),
      "query" => rule.fetch("query"),
      "queryFrequency" => duration(rule.fetch("queryFrequency")),
      "queryPeriod" => duration(rule.fetch("queryPeriod")),
      "triggerOperator" => operator(rule.fetch("triggerOperator")),
      "triggerThreshold" => rule.fetch("triggerThreshold"),
      "suppressionDuration" => "PT5H",
      "suppressionEnabled" => false,
      "tactics" => rule.fetch("tactics"),
      "techniques" => rule.fetch("relevantTechniques"),
      "entityMappings" => rule.fetch("entityMappings"),
      "eventGroupingSettings" => rule.fetch("eventGroupingSettings", { "aggregationKind" => "SingleAlert" }),
      "customDetails" => rule.fetch("customDetails", {}),
      "incidentConfiguration" => {
        "createIncident" => true,
        "groupingConfiguration" => {
          "enabled" => true,
          "reopenClosedIncident" => false,
          "lookbackDuration" => "PT5H",
          "matchingMethod" => "Selected",
          "groupByEntities" => ["Account", "IP"],
          "groupByAlertDetails" => [],
          "groupByCustomDetails" => []
        }
      }
    }
  }
end

template = {
  "$schema" => "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion" => "1.0.0.0",
  "metadata" => {
    "description" => "Generated Microsoft Sentinel analytics rules. Do not edit; update Detections/*.yaml and rebuild.",
    "source" => "sentinel-detection-lab"
  },
  "parameters" => {
    "workspaceName" => { "type" => "string", "metadata" => { "description" => "Microsoft Sentinel Log Analytics workspace name." } },
    "enabled" => { "type" => "bool", "defaultValue" => false, "metadata" => { "description" => "Enable rules at deployment. Keep false for initial rollout." } }
  },
  "resources" => resources,
  "outputs" => {
    "analyticsRuleCount" => { "type" => "int", "value" => resources.length }
  }
}

dist = File.join(ROOT, "dist")
FileUtils.mkdir_p(dist)
output = File.join(dist, "analytics-rules.json")
File.write(output, JSON.pretty_generate(template) + "\n")
puts "Built #{resources.length} analytics rules: #{output.sub(ROOT + '/', '')}"
