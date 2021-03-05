defmodule RocketpayInfra.CachexCache do
  @cache_name :coin

  def get(key) do
    Cachex.get!(@cache_name, key)
  end

  def set(key, value, opts \\ []) do
    Cachex.put(@cache_name, key, value, opts)
  end

  def current_state() do
    Cachex.keys!(@cache_name)
  end
end
