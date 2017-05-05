json.array! @markers do |marker|
  json.lat marker.lat
  json.lng marker.lng
  json.title marker.title
  json.content marker.content
end