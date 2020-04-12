defmodule Organizingaproject6.CLI do
    @default_count 4
    
    def run(argv) do
        argv
        |> parse_args
        |> process
    end


    def process(:help) do
        IO.puts """
        usage: organiziangaproject6 <user> <project> [ count | #{@default_count}]
        """
        System.halt(0)
    end

    def process({code}) do
        code = Organizingaproject6.fetch(code)
        code = decode_response(code)
        content = xml_to_map(code)
        up = list_headers(code)
        print_info(content, up)
    end

    def decode_response({:ok, body, headers}), do: {body, headers} 

    def decode_response({:error, error}) do
        IO.puts "Error fetching from: #{error["message"]}"
        System.halt(2)
    end

    def xml_to_map({body, _headers}) do
        body
        |> XmlToMap.naive_map()
        |> content()
    end

    def content(body) do
        xml_map = body
        xml_map = xml_map["current_observation"]
        xml_map["#content"]
    end

    def list_headers({_body, headers}) do
        headers
        |> Enum.map(fn {x, y} -> {x == "Last-Modified", y} end)
        |> List.keyfind(true, 0)
        |> elem(1)
    end

    def print_info(content, up) do
        IO.puts "#{content["location"]}\n(#{content["station_id"]}) #{content["latitude"]}N #{content["longitude"]}W\nLast Updated: #{String.replace_leading(content["observation_time"], "Last Updated on ", "")}\n              #{up}\nWeather: #{content["weather"]}\nTemperature: #{content["temperature_string"]}\nDewpoint: #{content["dewpoint_string"]}\nRelative Humidity: #{content["relative_humidity"]}\nWind: #{content["wind_string"]}\nVisibility: #{content["visibility_mi"]}\nMSL Pressure: #{content["pressure_string"]}\nAltimeter: #{content["pressure_in"]} in Hg"
    end

    def parse_args(argv) do
        OptionParser.parse(argv, switches: [help: :boolean],
                                 aliases:  [h:    :help])
        |> elem(1)
        |> args_to_internal_representation()
    end
    
    def args_to_internal_representation([code, count]) do
        {code, String.to_integer(count)}        
    end

    def args_to_internal_representation([code]) do
        {code, @default_count}
    end

    def args_to_internal_representation(_) do
        :help
    end
end