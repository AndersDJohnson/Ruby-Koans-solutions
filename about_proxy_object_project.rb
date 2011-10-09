require File.expand_path(File.dirname(__FILE__) + '/edgecase')

# Project: Create a Proxy Class
#
# In this assignment, create a proxy class (one is started for you
# below).  You should be able to initialize the proxy object with any
# object.  Any messages sent to the proxy object should be forwarded
# to the target object.  As each message is sent, the proxy should
# record the name of the method send.
#
# The proxy class is started for you.  You will need to add a method
# missing handler and any other supporting methods.  The specification
# of the Proxy class is given in the AboutProxyObjectProject koan.

class Proxy
	attr_reader :messages
	def initialize(target_object)
		@object = target_object
		# ADD MORE CODE HERE
		@messages = []
	end
	
	def called?(msg)
		@messages.include?(msg)
	end
	
	def number_of_times_called(msg)
		@messages.count(msg)
	end

	# WRITE CODE HERE
	def method_missing(method_name, *args, &block)
		@messages << method_name
		@object.send(method_name, *args, &block)
	end
end

# The proxy object should pass the following Koan:
#
class AboutProxyObjectProject < EdgeCase::Koan
  def test_proxy_method_returns_wrapped_object
    # NOTE: The Television class is defined below
    tv = Proxy.new(Television.new)
    
    assert tv.instance_of?(Proxy)
  end
  
  def test_tv_methods_still_perform_their_function
    tv = Proxy.new(Television.new)
    
    tv.channel = 10
    tv.power
    
    assert_equal 10, tv.channel
    assert tv.on?
  end

  def test_proxy_records_messages_sent_to_tv
    tv = Proxy.new(Television.new)
    
    tv.power
    tv.channel = 10
    
    assert_equal [:power, :channel=], tv.messages
  end
  
  def test_proxy_handles_invalid_messages
    tv = Proxy.new(Television.new)
    
    assert_raise(NoMethodError) do
      tv.no_such_method
    end
  end
  
  def test_proxy_reports_methods_have_been_called
    tv = Proxy.new(Television.new)
    
    tv.power
    tv.power
    
    assert tv.called?(:power)
    assert ! tv.called?(:channel)
  end
  
  def test_proxy_counts_method_calls
    tv = Proxy.new(Television.new)
    
    tv.power
    tv.channel = 48
    tv.power

    assert_equal 2, tv.number_of_times_called(:power)
    assert_equal 1, tv.number_of_times_called(:channel=)
    assert_equal 0, tv.number_of_times_called(:on?)
  end

  def test_proxy_can_record_more_than_just_tv_objects
    proxy = Proxy.new("Code Mash 2009")

    proxy.upcase!
    result = proxy.split

    assert_equal ["CODE", "MASH", "2009"], result
    assert_equal [:upcase!, :split], proxy.messages
  end
end


# ====================================================================
# The following code is to support the testing of the Proxy class.  No
# changes should be necessary to anything below this comment.

# Example class using in the proxy testing above.
class Television
  attr_accessor :channel
  
  def power
    if @power == :on
      @power = :off
    else
      @power = :on
    end
  end
  
  def on?
    @power == :on
  end
end

# Tests for the Television class.  All of theses tests should pass.
class TelevisionTest < EdgeCase::Koan
  def test_it_turns_on
    tv = Television.new
    
    tv.power
    assert tv.on?
  end
  
  def test_it_also_turns_off
    tv = Television.new
    
    tv.power
    tv.power
    
    assert ! tv.on?
  end
  
  def test_edge_case_on_off
    tv = Television.new
    
    tv.power
    tv.power
    tv.power
        
    assert tv.on?
    
    tv.power
    
    assert ! tv.on?
  end

  def test_can_set_the_channel
    tv = Television.new

    tv.channel = 11
    assert_equal 11, tv.channel
  end
end
