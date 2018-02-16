require 'twitter'

class Client
  attr_reader :client

  def initialize()
    @client = Twitter::REST::Client.new(
      consumer_key: ENV['TWITTER_COMSUMER_KEY'],
      consumer_secret: ENV['TWITTER_COMSUMER_SECRET'],
      access_token: ENV['TWITTER_ACCESS_TOKEN'],
      access_token_secret: ENV['TWITTER_ACCESS_TOKEN_SECRET'],
    )
  end

  # twieet
  def twieet(str)
    @client.update str
  end

  def show_my_profile
    puts @client.user.screen_name      # アカウントID
    puts @client.user.name             # アカウント名
    puts @client.user.tweets_count     # ツイート数
    puts @client.user.followers_count  # フォロワー数
  end

  # タイムラインの表示
  def show_timeline
    @client.home_timeline.each do |tweet|
      puts tweet.full_text
      puts "FAVORITE: #{tweet.favorite_count}"
      puts "RETWEET : #{tweet.retweet_count}"
    end
  end

end
