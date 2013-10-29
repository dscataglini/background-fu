require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/../lib/job.rb'

class JobTest < Test::Unit::TestCase

  def setup
    ActiveRecord::Base.allow_concurrency = false
    @job = Job.new
  end

  should have_readonly_attribute :worker_class
  should have_readonly_attribute :worker_method
  should have_readonly_attribute :args

  should_validate_presence_of :worker_class, :worker_method

end
