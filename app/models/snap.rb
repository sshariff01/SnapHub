class Snap < ActiveRecord::Base
  def self.send_to_twitter
    client_stream = Twitter::Streaming::Client.new do |config|
      config.consumer_key = 'Dx5V1VzAGrFRfosfH7mn4G6bu'
      config.consumer_secret =  't4XG4rcexsh2bpSVkyar9P2NDvuoUFeteQ2wsjFEIUt6vY0E21'
      config.access_token = '2728693344-R0UZ5iJnt31OnuCSyQkyGqAD7wBbyPe8GO68pxI'
      config.access_token_secret = 'KdcTYayXEh4zGn6oNNdEvvWtjaM623clrRI07eePQZD8L'
    end
    
    client_stream.delay.filter(:track => "testphotographytag2014") do |object|
      puts object.text if object.is_a?(Twitter::Tweet)
    end
    
    puts 'DONE'
  end
end
