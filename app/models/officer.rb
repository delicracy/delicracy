class Officer
  attr_reader :race

  def initialize(race)
    @race = race
  end

  def transaction(member)
    CoinTransaction.apply(source: race, destination: member, amount: volume_for_payoff(member), basis: self)
  end 
end
