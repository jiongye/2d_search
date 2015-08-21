# function Dijkstra(Graph, source):
#  2
#  3      dist[source] ← 0                       // Distance from source to source
#  4      prev[source] ← undefined               // Previous node in optimal path initialization
#  5
#  6      create vertex set Q
#  7
#  8      for each vertex v in Graph:             // Initialization
#  9          if v ≠ source:                      // v has not yet been removed from Q (unvisited nodes)
# 10              dist[v] ← INFINITY             // Unknown distance from source to v
# 11              prev[v] ← UNDEFINED            // Previous node in optimal path from source
# 12          add v to Q                          // All nodes initially in Q (unvisited nodes)
# 13
# 14      while Q is not empty:
# 15          u ← vertex in Q with min dist[u]    // Source node in the first case
# 16          remove u from Q
# 17
# 18          for each neighbor v of u:           // where v is still in Q.
# 19              alt ← dist[u] + length(u, v)
# 20              if alt < dist[v]:               // A shorter path to v has been found
# 21                  dist[v] ← alt
# 22                  prev[v] ← u
# 23
# 24      return dist[], prev[]

# map is a hash of like: {[0, 1] => '.', [1, 1] => 'x' } '.' is space and 'x' is wall
# source and dest are array like [0, 0], it is the position of the map
# we can only move horizontally or vertically
def search_path(map, source, dest)

  distances = {source =>  {:distance => 0, :prev => nil, :visited => false}}

  target = source
  while !map.empty? && target != dest && !target.nil?
    x, y = target
    map.delete(target)

    [[x, y-1], [x, y+1], [x+1, y], [x-1, y]].each do |position|
      if map[position] == '.'
        alt_distance = distances[target][:distance] + 1
        distances[position] = {:distance => alt_distance, :prev => target} unless distances[position] && distances[position][:distance] <= alt_distance
      end
    end

    distances[target][:visited] = true

    not_visited = distances.select {|key, val| !val[:visited] }
    if not_visited.empty?
      target = nil
    else
      target = not_visited.sort_by {|key, val| val[:distance]}.first[0]
    end
  end

  reverse_path(distances, source, dest)
end

def reverse_path(distances, source, dest)
  if distances[dest]
    result = []
    target = dest

    while target
      result.unshift target
      target = distances[target][:prev]
    end
    result
  else
    -1
  end
end

def generate_map(file_path)
  map = {}
  File.readlines(file_path).each_with_index do |line, row|
    next if line.to_s.strip.empty?
    line.split(/\s+/).compact.each_with_index do |x, column|
      map[[column, row]] = x
    end
  end
  map
end

map = generate_map(File.expand_path('../map.txt', __FILE__))
path = search_path(map, [0, 0], [4, 3])
puts path.inspect