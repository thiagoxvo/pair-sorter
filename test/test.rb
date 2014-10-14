ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require '../app/pair_sorter.rb'
include Rack::Test::Methods
 
def app
  Sinatra::Application
end

describe "Pair Sorter" do

  it "requires at least 4 people" do
    sorter = -> { Sorter.new({people: [1,2,3], teams:[]}) }
    sorter.must_raise ArgumentError
  end

  it "requires an even number of people" do
    sorter = proc { Sorter.new({people: [1,2,3,4,5], teams:[]}) }
    sorter.must_raise ArgumentError
  end

  it "should create initial pairs" do
    people = [1,2,3,4]
    teams = ["A", "B"]
    sorter = Sorter.new({people: people, teams:teams})
    sorter.current_pairs.must_equal [[1,3,"A"],[2,4,"B"]]
  end

  describe "sorting" do

    let(:people) { [1,2,3,4,5,6] }
    let(:teams) { ["GhostBusters", "DuckTales", "Transformers"] }

    it "check if all possibilities was generated after 50 rotations" do
      possible_combinations = (people.combination(2).to_a.product teams).size
      sorter = Sorter.new({people:people, teams:teams})
      35.times { sorter.switch_pairs }
      sorter.count_statistics.size.must_be :>=, possible_combinations
    end

    #it "test probability" do
      #sorter = Sorter.new({people:people, teams:teams})
      #1000.times { sorter.switch_pairs }
      #require 'ap'
      #ap sorter.count_statistics
    #end
  end
end
