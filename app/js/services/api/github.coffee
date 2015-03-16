@app.factory 'Github', ($http) ->
  commitActivity: (owner, repo) ->
    $http.get("https://api.github.com/repos/#{owner}/#{repo}/stats/commit_activity").then(
      (response) -> response.data
      (response) -> []
    )

  codeFrequency: (owner, repo) ->
    $http.get("https://api.github.com/repos/#{owner}/#{repo}/stats/code_frequency").then(
      (response) -> response.data
      (response) -> []
    )
