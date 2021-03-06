module Gitlab
  module Metrics
    # Class for storing details of a single metric (label, value, etc).
    class Metric
      attr_reader :series, :values, :tags, :created_at

      # series - The name of the series (as a String) to store the metric in.
      # values - A Hash containing the values to store.
      # tags   - A Hash containing extra tags to add to the metrics.
      def initialize(series, values, tags = {})
        @values     = values
        @series     = series
        @tags       = tags
        @created_at = Time.now.utc
      end

      # Returns a Hash in a format that can be directly written to InfluxDB.
      def to_hash
        {
          series: @series,
          tags:   @tags.merge(
            hostname:       Metrics.hostname,
            ruby_engine:    RUBY_ENGINE,
            ruby_version:   RUBY_VERSION,
            gitlab_version: Gitlab::VERSION,
            process_type:   Sidekiq.server? ? 'sidekiq' : 'rails'
          ),
          values:    @values,
          timestamp: @created_at.to_i
        }
      end
    end
  end
end
