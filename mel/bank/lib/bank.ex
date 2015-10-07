defmodule Bank do
  import Enum,    only: [reduce: 3]
  import Process, only: [send: 3]

  def start, do: await []

  def await hs do
    receive do
      { :check_balance, pid } -> send_balance pid, hs
      h = { :deposit,  _val } -> hs = [ h | hs ]
      h = { :withdraw, _val } -> hs = [ h | hs ]
    end

    await hs
  end

  defp send_balance(pid, hs), do: send pid, { :balance, calc_balance(hs) }, []

  defp calc_balance(hs), do: reduce hs, 0, &balance_reducer/2

  defp balance_reducer({ :deposit, val }, acc),  do: acc + val
  defp balance_reducer({ :withdraw, val }, acc), do: acc - val
  defp balance_reducer(_h, acc), do: acc
end
