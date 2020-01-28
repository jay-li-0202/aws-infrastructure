DENY SELECT, VIEW DEFINITION ON [wms].[__EFMigrationsHistoryWmsBuilding]        TO [${user}];
DENY SELECT, VIEW DEFINITION ON [wms].[Buildings]                               TO [${user}];
DENY SELECT, VIEW DEFINITION ON [wms].[BuildingUnit_BuildingPersistentLocalIds] TO [${user}];
DENY SELECT, VIEW DEFINITION ON [wms].[BuildingUnits]                           TO [${user}];
DENY SELECT, VIEW DEFINITION ON [wms].[ProjectionStates]                        TO [${user}];

DENY SELECT, VIEW DEFINITION ON [wms].[GebouwView]                              TO [${user}];
DENY SELECT, VIEW DEFINITION ON [wms].[GebouweenheidView]                       TO [${user}];

DENY SELECT, VIEW DEFINITION ON SCHEMA::[INFORMATION_SCHEMA]                    TO [${user}];
