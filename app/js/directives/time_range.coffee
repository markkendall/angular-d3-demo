@app.directive 'timeRange', ->
  restrict: 'E'
  replace: true
  scope:
    start: '='
    end: '='
    min: '='
    max: '='

  template: '<div></div>'

  link: (scope, element) ->
    initSlider = ->
      if scope.min && scope.max
        element.dateRangeSlider {
          bounds:
            min: scope.min
            max: scope.max
          defaultValues:
            min: scope.min
            max: scope.max
        }

    element.on 'valuesChanging', (event, data) ->
      scope.start = data.values.min
      scope.end = data.values.max
      scope.$apply()

    scope.$watch 'min', initSlider
    scope.$watch 'max', initSlider
