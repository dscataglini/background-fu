require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/../lib/job.rb'

class Foo
  def self.bar(*args)
    args
  end

  def baz(*args)
    args
  end
end

class JobTest < Test::Unit::TestCase

  def setup
    @job = Job.new
  end

  should have_readonly_attribute :worker_class
  should have_readonly_attribute :worker_method
  should have_readonly_attribute :args

  should_validate_presence_of :worker_class, :worker_method

  context "invoking a class method" do
    setup do
      @job = Job.enqueue!("Foo", "class.bar", 1, 2, 3)
    end

    should "not raise an error but execute such method" do
      assert_nothing_raised do
        @job.get_done!
      end
    end

    should "execute the class method" do
      Foo.expects(:bar).with(1, 2, 3)
      @job.get_done!
    end
  end

  context "invoking an instance method" do
    setup do
      @job = Job.enqueue!("Foo", "baz", :a, :b, :c)
    end

    should "execute the instance method" do
      mock_foo = mock
      Foo.expects(:new).returns(mock_foo)
      mock_foo.expects(:baz).with(:a, :b, :c)
      @job.get_done!
    end

  end

end
