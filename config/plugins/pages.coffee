module.exports = (lineman) ->
  delete lineman.config.application.pages.dev.files
  delete lineman.config.application.pages.dist.files
