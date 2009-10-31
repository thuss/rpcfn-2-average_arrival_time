require File.dirname(__FILE__) + '/spec_helper.rb'

describe ArrivalCalculator do
  include ArrivalCalculator
  
  it "should throw an exception on unexpected values" do
    lambda { average_time_of_day(["26:41am", "6:51am"]) }.should raise_error(ArgumentError)
  end
  
  it "should handle a single time" do
    average_time_of_day(["6:41am"]).should eql "6:41am"
  end
  
  it "should average times on the same day" do
    average_time_of_day(["6:41am", "6:51am", "7:01am"]).should eql "6:51am"
  end

  it "should average times across the day boundary" do
    average_time_of_day(["11:51pm", "11:56pm", "12:01am", "12:06am", "12:11am"]).should eql "12:01am"
  end
  
  it "should assume night when night is favored by one minute" do
    average_time_of_day(["6:01pm", "6:00am"]).should eql "12:00am"  
  end
  
  it "should assume day when day is favored by one minute" do
    average_time_of_day(["6:00pm", "6:01am"]).should eql "12:00pm"  
  end
  
  it "should assume daytime when the times are ambiguous" do
    average_time_of_day(["6:00pm", "6:00am"]).should eql "12:00pm"  
  end
  
  it "should assume night when the middle time indicates night" do
    average_time_of_day(["6:00pm", "12:00am", "6:00am"]).should eql "12:00am"  
  end
  
  it "should assume day when the middle time indicates day" do
    average_time_of_day(["6:00pm", "12:00pm", "6:00am"]).should eql "12:00pm"  
  end
  
  it "should handle various outlier scenarios" do
    average_time_of_day(["5:59pm", "7:00pm", "12:01am"]).should eql "8:20pm"  
    average_time_of_day(["3:00am", "4:00am", "11:59pm"]).should eql "2:19am"  
    average_time_of_day(["12:01am", "3:00am", "4:00am", "1:00pm"]).should eql "5:00am"  
  end
end
