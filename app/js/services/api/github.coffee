@app.factory 'Github', ($http) ->
  baseUrl: 'https://api.github.com'
  repoUrl: (owner, repo) -> "#{@baseUrl}/repos/#{owner}/#{repo}"

  commitActivity: (owner, repo) ->
    url = "#{@repoUrl(owner, repo)}/stats/commit_activity"
    $http.get(url).then(
      (response) -> response.data
      (response) -> []
    )

  codeFrequency: (owner, repo) ->
    url = "#{@repoUrl(owner, repo)}/stats/code_frequency"
    $http.get(url).then(
      (response) -> response.data
      (response) -> []
    )
