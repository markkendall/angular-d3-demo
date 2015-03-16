@app.config ($stateProvider, $locationProvider) ->

  $stateProvider
    .state 'stats',
      url: '/stats/:user/:repo'
      templateUrl: 'templates/stats.html'
      controller: 'StatsController'
      resolve:
        commits:
          ($stateParams, Github) ->
            Github.commitActivity($stateParams.user, $stateParams.repo)
        changes:
          ($stateParams, Github) ->
            Github.codeFrequency($stateParams.user, $stateParams.repo)

  # $locationProvider.html5Mode(enabled: true, requireBase: false)
