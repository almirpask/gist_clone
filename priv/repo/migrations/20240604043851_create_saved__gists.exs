defmodule ElixirGist.Repo.Migrations.CreateSavedGists do
  use Ecto.Migration

  def change do
    create table(:saved__gists, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :gist_id, references(:gists, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:saved__gists, [:user_id])
    create index(:saved__gists, [:gist_id])
  end
end
