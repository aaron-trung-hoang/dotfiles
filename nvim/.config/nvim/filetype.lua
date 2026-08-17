local function helm_template(path)
  local chart = vim.fs.find("Chart.yaml", {
    path = vim.fs.dirname(path),
    upward = true,
    type = "file",
  })[1]

  if chart then
    return "helm"
  end
end

-- YAML files below a chart's templates directory contain Go templates and
-- must not be parsed as plain YAML. The Chart.yaml check avoids classifying
-- unrelated directories named templates as Helm charts.
vim.filetype.add({
  pattern = {
    [".*/templates/.*%.yaml"] = helm_template,
    [".*/templates/.*%.yml"] = helm_template,
  },
})
