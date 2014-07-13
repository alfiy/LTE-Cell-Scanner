% Jiao Xianjun (putaoshu@gmail.com; putaoshu@msn.com)
% CellSearch.m
% Improved LTE-Cell-Scanner (written by James Peroulas: https://github.com/Evrytania/LTE-Cell-Scanner).
% See also README in root directory, ../test, ../../rtl-sdr-LTE/scan-capture/.

% Some scripts are borrowed from:
% https://github.com/JiaoXianjun/rtl-sdr-LTE
% https://github.com/Evrytania/LTE-Cell-Scanner
% https://github.com/Evrytania/Matlab-Library
% https://github.com/JiaoXianjun/multi-rtl-sdr-calibration

clear all;
close all;

test_source_info = regression_test_source('../regression_test_signal_file');

sampling_carrier_twist = 0;
f_search_set = -100e3:5e3:100e3;
pss_peak_max_reserve = 1;
num_pss_period_try = 3;
combined_pss_peak_range = 160;

filename = ['CellSearch_test_twist' num2str(sampling_carrier_twist) '_fo' num2str(min(f_search_set)) 'to' num2str(max(f_search_set)) '_resv' num2str(pss_peak_max_reserve) '_numPtry' num2str(num_pss_period_try) '_Prange' num2str(combined_pss_peak_range) '.mat'];

cell_info = cell(1, length(test_source_info));
for i = 1 : length(test_source_info)
    coef_pbch = pbch_filter_coef_gen(test_source_info(i).fs);
    
    r_raw = get_signal_from_bin(test_source_info(i).filename, inf, test_source_info(i).dev);
    r_raw = r_raw - mean(r_raw); % remove DC

    r_pbch = filter_wo_tail(r_raw, coef_pbch, (30.72e6/16)/test_source_info(i).fs);
    cell_info{i} = CellSearch(r_pbch, [], f_search_set, test_source_info(i).fc, sampling_carrier_twist, pss_peak_max_reserve, num_pss_period_try, combined_pss_peak_range);
    save(filename, 'test_source_info', 'cell_info');
end
