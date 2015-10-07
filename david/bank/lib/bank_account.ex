defmodule BankAccount do
  def start do
    await([])
  end

  def await events do
    receive do
      { :check_balance, pid }        -> send_balance pid, events
      event = { :deposit, _amount }  -> events = [event | events]
      event = { :withdraw, _amount } -> events = [event | events]
    end
    await events
  end

  defp send_balance pid, events do
    Process.send pid, {:balance, current_balance(events)}, []
  end

  defp current_balance events do
    Enum.reduce events, 0, &amount_reducer/2
  end

  defp amount_reducer({:deposit, amount}, acc),  do: acc + amount
  defp amount_reducer({:withdraw, amount}, acc), do: acc - amount
  defp amount_reducer({_type, amount}, acc),     do: acc
end
