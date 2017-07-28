defmodule BorsNG.LayoutView do
  @moduledoc """
  The common wrapper for all pages; namely,
  the bar along the top and the disclaimer along the bottom.
  """

  use BorsNG.Web, :view

  def get_version do
    get_heroku_commit() || get_git_commit() || get_release_version()
  end

  def get_heroku_commit do
    "HEROKU_SLUG_COMMIT"
    |> System.get_env()
    |> case do
      nil -> nil
      commit -> String.slice(commit, 0..10)
    end
  end

  def get_git_commit do
    ".git/HEAD"
    |> File.read()
    |> case do
      {:ok, "ref: " <> branch} ->
        branch = String.trim(branch)
        case File.read(".git/" <> branch) do
          {:ok, commit} -> String.trim(commit)
          _ -> nil
        end
      {:ok, commit} -> String.trim(commit)
      _ -> nil
    end
    |> case do
      nil -> nil
      commit -> String.slice(commit, 0..10)
    end
  end

  def get_release_version do
    case :application.get_key(:vsn) do
      {:ok, vsn} -> List.to_string('v' ++ vsn)
      _ -> nil
    end
  end
end
