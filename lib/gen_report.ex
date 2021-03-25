defmodule GenReport do
  alias GenReport.Parser

  @people [
    "daniele",
    "mayk",
    "giuliano",
    "cleiton",
    "jakeliny",
    "joseph",
    "diego",
    "danilo",
    "rafael",
    "vinicius"
  ]

  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.to_list()
    |> Enum.reduce(report_acc(), fn line, acc -> sum_lines(line, acc) end)
  end

  defp report_acc() do
    all_hours = all_hours_structure()
    hours_per_month = hours_per_month_structure()
    hours_per_year = hours_per_year_structure()

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp sum_lines([name, hours, _day, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => hours_per_month,
         "hours_per_year" => hours_per_year
       }) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    month_name = Enum.at(@months, month - 1)

    hours_per_month =
      put_in(hours_per_month[name][month_name], hours_per_month[name][month_name] + hours)

    hours_per_year = put_in(hours_per_year[name][year], hours_per_year[name][year] + hours)

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp all_hours_structure, do: Enum.into(@people, %{}, &{&1, 0})

  defp hours_per_month_structure do
    months = Enum.into(@months, %{}, &{&1, 0})
    Enum.into(@people, %{}, &{&1, months})
  end

  defp hours_per_year_structure do
    years = Enum.into(2016..2020, %{}, &{&1, 0})
    Enum.into(@people, %{}, &{&1, years})
  end

  defp build_report(all_hours, hours_per_month, hours_per_year) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end
end
