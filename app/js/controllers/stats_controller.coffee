@app.controller 'StatsController', ($scope, $stateParams, commits, changes) ->
  $scope.user = $stateParams.user
  $scope.repo = $stateParams.repo
  $scope.commits = ({time: new Date(s.week * 1000), value: s.total} for s in commits)
  $scope.additions = ({time: new Date(s[0] * 1000), value: s[1] / 1000} for s in changes)
  $scope.deletions = ({time: new Date(s[0] * 1000), value: -s[2] / 1000} for s in changes)

  range = _.filter($scope.commits, (s) -> s.value > 0)
  $scope.startTime = $scope.minTime = _.first(range)?.time
  $scope.endTime = $scope.maxTime = _.last(range)?.time
