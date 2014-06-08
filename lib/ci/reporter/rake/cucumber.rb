require 'ci/reporter/rake/utils'

namespace :ci do
  namespace :setup do
    task :cucumber_report_cleanup do
      rm_rf ENV["CI_REPORTS"] || "features/reports"
    end

    task :cucumber => :cucumber_report_cleanup do
      ENV["CUCUMBER_OPTS"] = "#{ENV['CUCUMBER_OPTS']} --format CI::Reporter::Cucumber"
    end
  end
end
