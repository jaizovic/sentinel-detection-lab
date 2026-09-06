#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "yaml"
require "set"

ROOT = File.expand_path("..", __dir__)
RULE_GLOB = File.join(ROOT, "Detections", "**", "*.yaml")
UUID = /\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i
REQUIRED = %w[id name description severity status kind version owner requiredDataConnectors queryFrequency queryPeriod triggerOperator triggerThreshold tactics relevantTechniques query entityMappings falsePositives investigation].freeze
SEVERITIES = %w[Informational Low Medium High].freeze

def yaml_file(path)
  YAML.safe_load(File.read(path), [], [], false)
rescue ArgumentError
  YAML.safe_load(File.read(path), permitted_classes: [], permitted_symbols: [], aliases: false)
end

errors = []
rules = Dir.glob(RULE_GLOB).sort.map do |path|
  begin
    rule = yaml_file(path)
    unless rule.is_a?(Hash)
      errors << "#{path}: root must be a mapping"
      next
    end
    missing = REQUIRED.reject { |key| rule.key?(key) && !rule[key].nil? && rule[key] != "" }
    errors << "#{path}: missing #{missing.join(', ')}" unless missing.empty?
    errors << "#{path}: id is not a UUID" unless rule["id"].to_s.match?(UUID)
    errors << "#{path}: unsupported severity #{rule['severity']}" unless SEVERITIES.include?(rule["severity"])
    errors << "#{path}: kind must be Scheduled" unless rule["kind"] == "Scheduled"
    errors << "#{path}: query must reference a table and contain a pipe" unless rule["query"].to_s.match?(/\A[A-Za-z][A-Za-z0-9_]*\s*\n\s*\|/m) || rule["query"].to_s.include?("let ")
    errors << "#{path}: entityMappings must not be empty" unless rule["entityMappings"].is_a?(Array) && !rule["entityMappings"].empty?
    errors << "#{path}: requiredDataConnectors must not be empty" unless rule["requiredDataConnectors"].is_a?(Array) && !rule["requiredDataConnectors"].empty?
    [path, rule]
  rescue StandardError => e
    errors << "#{path}: YAML parse failed: #{e.message}"
    nil
  end
end.compact

ids = rules.map { |_, rule| rule["id"] }
names = rules.map { |_, rule| rule["name"] }
errors << "duplicate rule IDs: #{ids.group_by(&:itself).select { |_, values| values.length > 1 }.keys.join(', ')}" unless ids.uniq.length == ids.length
errors << "duplicate rule names detected" unless names.uniq.length == names.length

mapping_path = File.join(ROOT, "Governance", "control-mapping.yaml")
begin
  mapping = yaml_file(mapping_path)
  mapped_ids = mapping.fetch("mappings").map { |item| item.fetch("ruleId") }
  errors << "governance mappings missing rule IDs: #{(ids - mapped_ids).join(', ')}" unless (ids - mapped_ids).empty?
  errors << "governance mappings reference unknown rule IDs: #{(mapped_ids - ids).join(', ')}" unless (mapped_ids - ids).empty?
rescue StandardError => e
  errors << "#{mapping_path}: mapping validation failed: #{e.message}"
end

json_files = Dir.glob(File.join(ROOT, "{Playbooks,Workbooks}", "**", "*.json"))
json_files.each do |path|
  begin
    parsed = JSON.parse(File.read(path))
    errors << "#{path}: ARM template schema missing" unless parsed["$schema"].to_s.include?("deploymentTemplate.json")
    errors << "#{path}: ARM resources missing" unless parsed["resources"].is_a?(Array) && !parsed["resources"].empty?
  rescue JSON::ParserError => e
    errors << "#{path}: JSON parse failed: #{e.message}"
  end
end

tracked_text = Dir.glob(File.join(ROOT, "**", "*"), File::FNM_DOTMATCH).select { |p| File.file?(p) && !p.include?("/.git/") }
tracked_text.each do |path|
  content = File.read(path, mode: "rb").force_encoding("UTF-8")
  next unless content.valid_encoding?
  errors << "#{path}: contains a hard-coded Azure subscription resource ID" if content.match?(%r{/subscriptions/[0-9a-f]{8}-[0-9a-f-]{27,}}i)
  errors << "#{path}: contains an unresolved secret-like assignment" if content.match?(/(?:client_secret|api_key|password)\s*[:=]\s*["'][^<\[@][^"']{8,}["']/i)
end

if errors.empty?
  puts "Validation passed: #{rules.length} analytics rules, #{json_files.length} ARM templates, and complete governance mappings."
  exit 0
end

warn "Validation failed with #{errors.length} error(s):"
errors.each { |error| warn "- #{error.sub(ROOT + '/', '')}" }
exit 1
