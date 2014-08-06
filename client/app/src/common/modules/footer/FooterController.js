var FooterController = function($scope, $log, $modal, $location, weekService, leagueService, seasonModel) {

  $scope.season = seasonModel.season;

  $scope.joinLeague = function(season) {
    $location.path('/season/' + season.id + '/leagues/public');
  };

  $scope.createLeague = function(season) {

    var modalInstance = $modal.open({
      templateUrl: 'modules/private/league/new/league.new.tpl.html',
      controller: 'NewLeagueController',
      resolve: {
        weeks: function() {
          return weekService.getAvailableWeeks(season.id);
        }
      }

    });

    modalInstance.result.then(function(league) {
      leagueService.createLeague(league);
    }, function () {
      $log.debug('Create league modal dismissed...');
    });

  };

  $scope.manageTeams = function(season) {
    $location.path('/season/' + season.id + '/teams/alive');
  };

  $scope.manageLeagues = function(season) {
    $location.path('/season/' + season.id + '/leagues');
  };

  /**
   * Invoked on startup, like a constructor.
   */
  var init = function () {
    $log.debug("footer controller");
  };
  init();
};

FooterController.$inject = ['$scope', '$log', '$modal', '$location', 'weekService', 'leagueService', 'seasonModel'];
module.exports = FooterController;
