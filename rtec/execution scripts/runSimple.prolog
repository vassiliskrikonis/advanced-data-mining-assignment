:-['./continuousQueries.prolog'].
:-['../CE\ patterns/simpleMaritimePatterns/compiled_patterns.prolog'].
:-['../CE\ patterns/simpleMaritimePatterns/declarations.prolog'].
:-['../data/static/loadStaticData.prolog'].
:-['../utils/loadUtils.prolog'].

run :-
    continuousER('../data/dynamic/dataset_RTEC_maritime_example.txt','../results/maritime_results_simple.txt','../results/stats_times_simple.txt','../results/stats_input_simple.txt',1443650401,1443851479,7200,7200).
