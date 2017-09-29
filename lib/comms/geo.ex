defmodule Geo do
  def locate(nil), do: %{}
  def locate(ip_address) do
    result = Geolix.lookup(ip_address, [where: :city])

    %{
      country_name: result.country.name,
      country_code: result.country.iso_code,
      city_name: result.city && result.city.name,
      coordinates: [result.location.longitude, result.location.latitude],
      latitude: result.location.latitude,
      longitude: result.location.longitude
    }
  end
end
