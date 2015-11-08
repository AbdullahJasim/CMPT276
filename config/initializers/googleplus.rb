GooglePlus.api_key = 'AIzaSyAGCNNClC8yspcpJ3WIMro-I6_j1Jyel0E'

search = GooglePlus::Person.search('sfu')
search.each do |p|
  puts p.display_name
end
