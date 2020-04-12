defmodule CliTest do
    use ExUnit.Case
    doctest Organizingaproject6

    import Organizingaproject6.CLI, only: [parse_args: 1]

    test ":help returned by option parsing with -h and --help options" do
        assert parse_args(["-h", "anything"])  == {"anything", 4}
        assert parse_args(["--help", "anything"]) == {"anything", 4}
    end

    test "three values returned if three given" do
        assert parse_args(["code", "99"]) == {"code", 99}
    end

    test "count is defaulted if two values given" do
        assert parse_args(["code"]) == {"code", 4}
    end
end