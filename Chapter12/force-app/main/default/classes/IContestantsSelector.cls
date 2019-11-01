public interface IContestantsSelector extends fflib_ISObjectSelector {
    Map<Id, List<ContestantsSelector.Summary>> selectByRaceIdWithContestantSummary(Set<Id> raceIds);
}