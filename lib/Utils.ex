defmodule Util do
  def frequencies(list) do
    Enum.reduce(list, %{}, fn item, acc ->
      Map.update(acc, item, 1, &(&1 + 1))
    end)
  end
end
