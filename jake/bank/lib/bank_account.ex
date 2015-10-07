defmodule BankAccount do
  def start do
    await
  end

  def await, do: await([])
  def await(events) do
    receive do
      {:check_balance, pid}        -> send_balance(events, pid)
      event = {:deposit, _amount}  -> events = [event | events]
      event = {:withdraw, _amount} -> events = [event | events]
      {:transfer, to_pid, amount}  ->
        events = [{:withdraw, amount} | events]
        Process.send(to_pid, {:deposit, amount}, [])
    end
    await(events)
  end

  def send_balance(events, pid) do
    Process.send(pid, {:balance, calc_balance(events)}, [])
  end

  def calc_balance(events) do
    Enum.reduce(events, 0, &amount_reducer/2)
  end

  def amount_reducer({:deposit, amount}, acc),  do: acc + amount
  def amount_reducer({:withdraw, amount}, acc), do: acc - amount
end
