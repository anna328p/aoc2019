require './traversal'
### PATHFINDING ###

def neighbors c
  [
    [c[0] + 1, c[1]],
    [c[0] - 1, c[1]],
    [c[0], c[1] + 1],
    [c[0], c[1] - 1]
  ]
end

def dist(cur, n)
  return 1
end

def reconstruct_path(came_from, current)
  total_path = [current]
  while came_from.keys.include? current
    current = came_from[current]
    total_path.unshift current
  end
  return total_path
end

def a_star(start, goal, **kwargs)
  open_set = Set[start]

  came_from = {}

  g_score = Hash.new 1000000000000
  g_score[start] = 0

  f_score = Hash.new 1000000000000
  f_score[start] = yield(start)

  until open_set.empty?
    current = open_set.min_by { |n| f_score[n] }
    if current == goal
      return reconstruct_path(came_from, current)
    end

    open_set.delete current
    neighbors(current).each do |neighbor|
      tentative_g_score = g_score[current] + dist(current, neighbor)
      if tentative_g_score < g_score[neighbor]
        came_from[neighbor] = current
        g_score[neighbor] = tentative_g_score
        f_score[neighbor] = g_score[neighbor] + yield(neighbor)
        if not open_set.include? neighbor
          open_set.add neighbor
        end
      end
    end

    if kwargs[:points] && $VERBOSE == true
      print "\u001B[0;0H"
      show kwargs[:points], *reconstruct_path(came_from, current), src: start, dst: goal
    end
  end

  return nil
end
