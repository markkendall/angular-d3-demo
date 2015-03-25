@app.directive 'timeGraph', ($window, TimeGraph) ->
  restrict: 'E'
  replace: true
  scope:
    id: '='
    heading: '='
    data: '='
    unit: '='
    start: '='
    end: '='

  templateUrl: 'templates/directives/time_graph.html'

  link: (scope, element) ->
    redraw = ->
      if scope.data && scope.start && scope.end
        TimeGraph.draw(
          element.find('.chart'),
          scope.id,
          scope.data,
          scope.unit,
          scope.start,
          scope.end
        )

    scope.$watch 'start', redraw
    scope.$watch 'end', redraw

    resizeHandler = ->
      redraw()
      scope.$apply()

    $($window).on 'resize', resizeHandler
    scope.$on '$destroy', ->
      $($window).off 'resize', resizeHandler
