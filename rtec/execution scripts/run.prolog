:-['./continuousQueries.prolog'].
:-['../CE\ patterns/compiled_patterns.prolog'].
:-['../CE\ patterns/declarations.prolog'].
:-['../data/static/loadStaticData.prolog'].
:-['../utils/loadUtils.prolog'].

run :-
    continuousER('../data/dynamic/dataset_RTEC_maritime_example.txt','/opt/results/maritime_results.txt','/opt/results/stats_times.txt','/opt/results/stats_input.txt',1443650401,1443851479,7200,7200).
