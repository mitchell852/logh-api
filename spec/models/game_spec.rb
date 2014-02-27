require 'spec_helper'

describe Game do

  it { should respond_to(:week) }
  its(:week) { should be_nil }

  it { should respond_to(:start_datetime) }
  its(:start_datetime) { should be_nil }

  it { should respond_to(:home_squad) }
  its(:home_squad) { should be_nil }

  it { should respond_to(:home_squad_score) }
  its(:home_squad_score) { should be_nil }

  it { should respond_to(:visiting_squad) }
  its(:visiting_squad) { should be_nil }

  it { should respond_to(:visiting_squad_score) }
  its(:visiting_squad_score) { should be_nil }

  context 'when it has no week' do
    subject(:game) { FactoryGirl.build(:game, week: nil) }
    it { should_not be_valid }
  end

  context 'when it has no start_datetime' do
    subject(:game) { FactoryGirl.build(:game, start_datetime: nil) }
    it { should_not be_valid }
  end

  context 'when it has no home squad' do
    subject(:game) { FactoryGirl.build(:game, home_squad: nil) }
    it { should_not be_valid }
  end

  context 'when it has no visiting squad' do
    subject(:game) { FactoryGirl.build(:game, visiting_squad: nil) }
    it { should_not be_valid }
  end

  context 'when visiting squad score is less than home squad score' do
    subject(:game) { FactoryGirl.create(:game) }
    it 'should add visiting squad to the weeks losers' do
      game.update(home_squad_score: 34, visiting_squad_score: 24)
      expect(game.week.losers).to include(Loser.find_by(week: game.week, squad: game.visiting_squad))
    end
  end

  context 'when home squad score is less than visiting squad score' do
    subject(:game) { FactoryGirl.create(:game) }
    it 'should add home squad to the weeks losers' do
      game.update(home_squad_score: 21, visiting_squad_score: 24)
      expect(game.week.losers).to include(Loser.find_by(week: game.week, squad: game.home_squad))
    end
  end

  context 'when home squad score equals visiting squad score' do
    subject(:game) { FactoryGirl.create(:game) }
    it 'should not add either squad to the weeks losers' do
      game.update(home_squad_score: 14, visiting_squad_score: 14)
      expect(game.week.losers).not_to include(Loser.find_by(week: game.week, squad: game.home_squad))
      expect(game.week.losers).not_to include(Loser.find_by(week: game.week, squad: game.visiting_squad))
    end
  end

end