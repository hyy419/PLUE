%% Redraw manuscript Figures 2--8 without changing study.m
% This file is deliberately independent of study.m.  Run it from MATLAB
% R2023b after checking dataRoot and nitrogenRoot below.  It creates clean,
% editable MATLAB figures plus the journal-required EMF/PDF files in
% figure_redrawn.  Each Figure section can be run independently after the
% shared-data section above it has been run once.

clear; close all; clc

% WHICH is robust when this script is run as a selected Editor section.
codeRoot = fileparts(which('redraw_figures_2_to_8'));
projectRoot = fileparts(codeRoot);
dataRoot = fullfile(projectRoot, 'data');
nitrogenRoot = 'E:\matlab\matlab\PLUE\data\N'; % Change only if data are moved.
outDir = fullfile(projectRoot, 'figure_redrawn');
if ~isfolder(outDir), mkdir(outDir); end
addpath(codeRoot)

% A restrained, colour-blind-friendly palette used consistently throughout.
C.china = [0.00 0.37 0.63];
C.dprk = [0.84 0.33 0.10];
C.positive = [0.77 0.20 0.20];
C.negative = [0.14 0.33 0.64];
C.band = [0.72 0.75 0.79];
set(groot, 'defaultFigureColor', 'w', 'defaultAxesFontName', 'Microsoft YaHei UI', ...
    'defaultAxesFontSize', 8, 'defaultAxesLineWidth', 0.5, ...
    'defaultAxesTickDir', 'in', 'defaultAxesBox', 'off', ...
    'defaultAxesXGrid', 'off', 'defaultAxesYGrid', 'off', ...
    'defaultLineLineWidth', 0.5, 'defaultLegendBox', 'off');

%% Shared masks, geometry and time series
load(fullfile(dataRoot, 'sa_info.mat'));             % box, S, bg, mask
load(fullfile(dataRoot, 'masksyr.mat'));             % mask1, mask2, mask_crop
load(fullfile(dataRoot, 'pre.mat'));                 % pre4
load(fullfile(dataRoot, 'tempmax.mat'));             % tempmax3
load(fullfile(dataRoot, 'tempmin.mat'));             % tempmin3

gridArea = ftx_make_grid_area(43200, 86400);
area = gridArea(bg(1):bg(2), bg(3):bg(4));
years = 2001:2024;
months = 1:12;
monthLabels = {'1月','3月','5月','7月','9月','11月'};
mask1crop = logical(mask1 .* mask_crop);
mask2crop = logical(mask2 .* mask_crop);
rain4 = reshape(pre4, 720, 720, 12, 24);
temp = (tempmax3 + tempmin3) ./ 2;
rainMonthly = reshape(pre4, 720, 720, 12*24);
tempMonthly = reshape(temp, 720, 720, 12*24);

rainSeries = { ...
    ftx_mask_areaweigh_ts(rainMonthly, area, mask1, 12, -1), ...
    ftx_mask_areaweigh_ts(rainMonthly, area, mask2, 12, -1), ...
    ftx_mask_areaweigh_ts(rainMonthly, area, mask1crop, 12, -1), ...
    ftx_mask_areaweigh_ts(rainMonthly, area, mask2crop, 12, -1)};
tempSeries = { ...
    ftx_mask_areaweigh_ts(tempMonthly, area, mask1, 12, -1), ...
    ftx_mask_areaweigh_ts(tempMonthly, area, mask2, 12, -1), ...
    ftx_mask_areaweigh_ts(tempMonthly, area, mask1crop, 12, -1), ...
    ftx_mask_areaweigh_ts(tempMonthly, area, mask2crop, 12, -1)};
panelNames = {'中国侧', '朝鲜侧', '中国侧农田', '朝鲜侧农田'};

%% Figure 2: seasonal climate patterns

% English panel labels
panelNames = {'China', 'DPRK', ...
              'China farmland', 'DPRK farmland'};

panelNames2 = {'China', 'DPRK', ...
               'China farmland', 'DPRK farmland'};

% Y-axis labels
yLabelRain = 'Precipitation (mm)';
yLabelTemp = 'Temperature (^oC)';

f = figure('Units','centimeters','Position',[3 3 20 22]);

tiledlayout(4,2, ...
    'TileSpacing','compact', ...
    'Padding','compact');

for k = 1:4

    if k <= 2
        panelColor = C.china;
    else
        panelColor = C.dprk;
    end

    % Precipitation
    axRain(k) = nexttile(k);

    plotSeason(axRain(k),rainSeries{k},months,panelColor, ...
        sprintf('(%c)',char('a'+k-1)), ...
        yLabelRain,monthLabels);

    % Temperature
    axTemp(k) = nexttile(k+4);

    plotSeason(axTemp(k),tempSeries{k},months,panelColor, ...
        sprintf('(%c)',char('e'+k-1)), ...
        yLabelTemp,monthLabels);

end

% =========================================================
% Unify y-axis ranges
% =========================================================

% Row 1: China vs DPRK precipitation
yl = [ylim(axRain(1)); ylim(axRain(2))];
ymin = min(yl(:,1));
ymax = max(yl(:,2));

ylim(axRain(1),[ymin ymax]);
ylim(axRain(2),[ymin ymax]);

% Row 2: China vs DPRK farmland precipitation
yl = [ylim(axRain(3)); ylim(axRain(4))];
ymin = min(yl(:,1));
ymax = max(yl(:,2));

ylim(axRain(3),[ymin ymax]);
ylim(axRain(4),[ymin ymax]);

% Row 3: China vs DPRK temperature
yl = [ylim(axTemp(1)); ylim(axTemp(2))];
ymin = min(yl(:,1));
ymax = max(yl(:,2));

ylim(axTemp(1),[ymin ymax]);
ylim(axTemp(2),[ymin ymax]);

% Row 4: China vs DPRK farmland temperature
yl = [ylim(axTemp(3)); ylim(axTemp(4))];
ymin = min(yl(:,1));
ymax = max(yl(:,2));

ylim(axTemp(3),[ymin ymax]);
ylim(axTemp(4),[ymin ymax]);


exportgraphics(gcf, ...
    'C:\Users\Administrator\Desktop\投稿\6 JOURNAL OF APPLIED REMOTE SENSING\fig\2.tif', ...
    'Resolution',600);

%% Figure 3: Monthly climate trends


% Y-axis labels
yLabelRain = 'Precipitation (mm\cdot yr^{-1})';
yLabelTemp = 'Temperature (^oC\cdot yr^{-1})';

f = figure( ...
    'Units','centimeters', ...
    'Position',[3 3 20 18], ...
    'Color','w', ...
    'Renderer','painters');

tiledlayout(4,2, ...
    'TileSpacing','compact', ...
    'Padding','compact');

axRain = gobjects(4,1);
axTemp = gobjects(4,1);

for k = 1:4

    % Precipitation trend
    tr = f_matrix_trend(rainSeries{k},2);

    axRain(k) = nexttile(k);

    plotMonthlyTrend( ...
        axRain(k), ...
        tr, ...
        C, ...
        sprintf('(%c)',char('a'+k-1)), ...
        yLabelRain,monthLabels);

    % Temperature trend
    tr = f_matrix_trend(tempSeries{k},2);

    axTemp(k) = nexttile(k+4);

    plotMonthlyTrend( ...
        axTemp(k), ...
        tr, ...
        C, ...
        sprintf('(%c)',char('e'+k-1)), ...
        yLabelTemp,monthLabels);

end

% =========================================================
% Unify Y-axis ranges for each pair of subplots
% =========================================================

pairAxes = { ...
    [axRain(1) axRain(2)], ...
    [axRain(3) axRain(4)], ...
    [axTemp(1) axTemp(2)], ...
    [axTemp(3) axTemp(4)]};

for i = 1:numel(pairAxes)

    a = pairAxes{i};

    yl1 = ylim(a(1));
    yl2 = ylim(a(2));

    ylNew = [ ...
        min(yl1(1),yl2(1)), ...
        max(yl1(2),yl2(2))];

    ylim(a(1),ylNew);
    ylim(a(2),ylNew);

end

exportgraphics(gcf, ...
    'C:\Users\Administrator\Desktop\投稿\6 JOURNAL OF APPLIED REMOTE SENSING\fig\3.tif', ...
    'Resolution',600);





%另一种形式


%% Figure 4: Annual climate trajectories and fitted trends

% Y-axis labels
yLabelRain = 'Precipitation (mm)';
yLabelTemp = 'Temperature (^oC)';

f = figure( ...
    'Units','centimeters', ...
    'Position',[3 3 16 20], ...
    'Color','w', ...
    'Renderer','painters');

tiledlayout(4,2, ...
    'TileSpacing','compact', ...
    'Padding','compact');

axRain = gobjects(4,1);
axTemp = gobjects(4,1);

for k = 1:4

    if k <= 2
        c = C.china;
    else
        c = C.dprk;
    end

    % Precipitation
    axRain(k) = nexttile(k);

    plotAnnualTrend( ...
        axRain(k), ...
        years, ...
        sum(rainSeries{k},1,'omitnan'), ...
        c, ...
        sprintf('(%c)',char('a'+k-1)), ...
        yLabelRain);

    % Temperature
    axTemp(k) = nexttile(k+4);

    plotAnnualTrend( ...
        axTemp(k), ...
        years, ...
        mean(tempSeries{k},1,'omitnan'), ...
        c, ...
        sprintf('(%c)',char('e'+k-1)), ...
        yLabelTemp);

end

% =========================================================
% Unify Y-axis ranges for each pair of subplots
% =========================================================

pairAxes = { ...
    [axRain(1) axRain(2)], ...
    [axRain(3) axRain(4)], ...
    [axTemp(1) axTemp(2)], ...
    [axTemp(3) axTemp(4)]};

for i = 1:numel(pairAxes)

    a = pairAxes{i};

    yl1 = ylim(a(1));
    yl2 = ylim(a(2));

    ylNew = [min(yl1(1),yl2(1)), ...
             max(yl1(2),yl2(2))];

    ylim(a(1),ylNew);
    ylim(a(2),ylNew);

end


exportgraphics(gcf, ...
    'C:\Users\Administrator\Desktop\投稿\6 JOURNAL OF APPLIED REMOTE SENSING\fig\4.tif', ...
    'Resolution',600);

%% Figures 5--7: LAI maps, time series, and attribution maps
load(fullfile(dataRoot, 'LAI_Global_4D.mat'));      % lai_4d_global
load(fullfile(dataRoot, 'monthly_lai.mat'));        % monthly_avg
laiMonthly = reshape(lai_4d_global, 720, 720, 1104);
laiMean = squeeze(mean(mean(monthly_avg,3,'omitnan'),4,'omitnan'));
laiByYear = squeeze(mean(monthly_avg,3,'omitnan'));
[laiTrend,~,~,~] = f_grid_trend_mask(laiByYear);
laiMean(~mask) = nan; laiTrend(~mask_crop) = nan;


load ../data/monthly_lai.mat

laiMean(laiMean>10)=nan;%去除非mask部分
box=[44,41,128,131];%研究区经纬度
S = shaperead('../data/shp/merge_Dissolve.shp');



% 转成 single，减小文件体积
A1 = single(mask_crop);
A2 = single(laiTrend);


% 背景设为空白
A1(~mask) = NaN;
A2(~mask) = NaN;
% 获取分辨率
dlon = median(abs(diff(lons1(1,:))),'omitnan');
dlat = median(abs(diff(lats1(:,1))),'omitnan');

% 像元中心坐标 -> 像元边界范围
lonlim = [min(lons1(:))-dlon/2, ...
          max(lons1(:))+dlon/2];

latlim = [min(lats1(:))-dlat/2, ...
          max(lats1(:))+dlat/2];

% ---------------------------------------------------------
% 判断纬度方向
% GeoTIFF 通常按第一行为北侧来存储
% ---------------------------------------------------------
if lats1(1,1) < lats1(end,1)

    % 当前矩阵是南 -> 北，需要上下翻转
    A1 = flipud(A1);
    A2 = flipud(A2);

end

% ---------------------------------------------------------
% 建立地理参考
% ---------------------------------------------------------
R = georefcells( ...
    latlim, ...
    lonlim, ...
    size(A1), ...
    'ColumnsStartFrom','north');

% ---------------------------------------------------------
% 写出 GeoTIFF
% EPSG:4326 = WGS84
% ---------------------------------------------------------
geotiffwrite( ...
    'maskcrop.tif', ...
    A1, ...
    R, ...
    'CoordRefSysCode',4326);

geotiffwrite( ...
    'laiTrend.tif', ...
    A2, ...
    R, ...
    'CoordRefSysCode',4326);

disp('laiMean.tif 和 laiTrend.tif 已保存');




laiMean(~mask) = NaN;

figure('position',[50, 50, 1100, 360]);

% -------- 子图1：空间分布 --------
subplot(1, 2, 1);
flag = ftxp_plane_4_syria(box, S, 0.05, laiMean);  % 绘制空间分布
colormap(gca, slanCM(10));                         % 为当前坐标轴设置 colormap
colorbar;
caxis([0,3])
cb1 = colorbar;                                    % 创建 colorbar 对象
cb1.Title.String = 'm^{2}·m^{-2}';                   % 设置单位标签为标题
cb1.Title.FontSize = 10;                           % 设置字体大小
S3 = shaperead('../data/shp/merge.shp');
geoshow(S3, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 1);
% title('Annual LAI');
text(0.05, 0.9, '(a)', 'Units', 'normalized', 'FontSize', 16, 'FontWeight', 'bold');

% -------- 子图2：空间变化趋势 --------
subplot(1, 2, 2);
flag = ftxp_plane_4_syria(box, S, 0.05, laiTrend);   % 绘制趋势图
colormap(gca, slanCM(92));                         % 为当前坐标轴设置不同 colormap
caxis([-0.04, 0.04]);                                % 设置固定范围
cb2 = colorbar;                                    % 创建 colorbar 对象
cb2.Title.String = 'm^{2}·m^{-2}·yr^{-1}';           % 设置单位标签为标题
cb2.Title.FontSize =10;                           % 设置字体大小
cb2.Title.FontWeight = 'normal';
S3 = shaperead('../data/shp/merge.shp');
geoshow(S3, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 1);
% title('LAI Trend ');
text(0.05, 0.9, '(b)', 'Units', 'normalized', 'FontSize', 16, 'FontWeight', 'bold');


exportgraphics(gcf, ...
    'C:\Users\Administrator\Desktop\投稿\6 JOURNAL OF APPLIED REMOTE SENSING\fig\5.tif', ...
    'Resolution',600);



clear
%图6% ---------------------------------------------------------
load ../data/sa_info.mat %保持文件
load color_scheme_2018a.mat QH GDO;
load ../data/masksyr.mat 
load ../data/LAI_Global_4D.mat
laiMonthly = reshape(lai_4d_global, 720, 720, 1104);

mask1crop=logical(mask_crop.* mask1);
mask2crop=logical(mask_crop.* mask2);

laiSeries = {ftx_mask_areaweigh_ts(laiMonthly,area,mask1,46,-1), ...
             ftx_mask_areaweigh_ts(laiMonthly,area,mask2,46,-1), ...
             ftx_mask_areaweigh_ts(laiMonthly,area,mask1crop,46,-1), ...
             ftx_mask_areaweigh_ts(laiMonthly,area,mask2crop,46,-1)};


C.china = [0.00 0.37 0.63];
C.dprk = [0.84 0.33 0.10];
C.positive = [0.77 0.20 0.20];
C.negative = [0.14 0.33 0.64];
C.band = [0.72 0.75 0.79];


years = 2001:2024;

f = figure( ...
    'Units','centimeters', ...
    'Position',[3 3 24 8.6], ...
    'Color','w', ...
    'Renderer','painters');

tiledlayout(1,3, ...
    'TileSpacing','compact', ...
    'Padding','compact');

% (a) All-region LAI
plotLaiComparison( ...
    nexttile, ...
    years, ...
    mean(laiSeries{1},1,'omitnan'), ...
    mean(laiSeries{2},1,'omitnan'), ...
    C, ...
    '(a)');

% (b) Cropland LAI
plotLaiComparison( ...
    nexttile, ...
    years, ...
    mean(laiSeries{3},1,'omitnan'), ...
    mean(laiSeries{4},1,'omitnan'), ...
    C, ...
    '(b)');

% (c) Detrended cropland LAI correlation
plotLaiDetrendedScatter( ...
    nexttile, ...
    years, ...
    mean(laiSeries{3},1,'omitnan'), ...
    mean(laiSeries{4},1,'omitnan'), ...
    C, ...
    '(c)');



exportgraphics(gcf, ...
    'C:\Users\Administrator\Desktop\投稿\6 JOURNAL OF APPLIED REMOTE SENSING\fig\6.tif', ...
    'Resolution',600);


% ---------------------------------------------------------% ---------------------------------------------------------



rainAnnual = squeeze(mean(rain4,3,'omitnan'));
tempAnnual = squeeze(mean(reshape(temp,720,720,12,24),3,'omitnan'));
laiAnnual = squeeze(sum(lai_4d_global,3,'omitnan')) ./ 12;
[~,~,humanTrend,pHuman,fittedTrend] = f_grid_residual2(laiAnnual,rainAnnual,tempAnnual,mask);

human = abs(humanTrend) ./ (abs(humanTrend) + abs(fittedTrend));
climate = abs(fittedTrend) ./ (abs(humanTrend) + abs(fittedTrend));
human(pHuman >= .05) = nan; climate(pHuman >= .05) = nan;
human(~mask_crop) = nan; climate(~mask_crop) = nan;
[~,~,residualTrend,pResidual] = f_grid_residual(laiAnnual,rainAnnual,tempAnnual,mask_crop);
residualTrend(pResidual >= .05) = nan;
human(~mask_crop) = nan; 






% =========================================================
% 1. 计算有符号相对贡献率
% 气候变化贡献率 = Slope_LAI' / Slope_LAI × 100%
% 人类活动贡献率 = Slope_e / Slope_LAI × 100%
% 保留农田区域内所有有效像元，不进行显著性筛选
% =========================================================

% 根据趋势分解关系重建观测 LAI 趋势
observedTrend = humanTrend + fittedTrend;

% 初始化
human = nan(size(humanTrend));
climate = nan(size(fittedTrend));

% 保留农田区域内所有有效像元
valid = logical(mask_crop) ...
      & isfinite(humanTrend) ...
      & isfinite(fittedTrend) ...
      & isfinite(observedTrend);

% 排除观测趋势为零或非常接近零的像元
% 避免贡献率因分母接近零而异常放大
tol = 1e-8;
validRelative = valid & abs(observedTrend) > tol;

% 按照论文定义计算有符号相对贡献率
human(validRelative) = ...
    humanTrend(validRelative) ./ observedTrend(validRelative) * 100;

climate(validRelative) = ...
    fittedTrend(validRelative) ./ observedTrend(validRelative) * 100;

% 农田区域之外设为空
human(~mask_crop) = nan;
climate(~mask_crop) = nan;

% 检查贡献率之和
sumContribution = human + climate;
validSum = isfinite(sumContribution);

if any(validSum(:))
    fprintf('有效像元贡献率之和的平均值：%.4f%%\n', ...
        mean(sumContribution(validSum),'omitnan'));
end

% =========================================================
% 2. 中国侧、朝鲜侧农田面积加权平均相对贡献率
% =========================================================

A = double(area);

validChina = logical(mask1crop) ...
           & isfinite(human) & isfinite(climate) ...
           & isfinite(A) & A > 0;

validDPRK = logical(mask2crop) ...
          & isfinite(human) & isfinite(climate) ...
          & isfinite(A) & A > 0;

% 中国侧
humanChina = sum(human(validChina).*A(validChina),'omitnan') ...
           / sum(A(validChina),'omitnan');

climateChina = sum(climate(validChina).*A(validChina),'omitnan') ...
             / sum(A(validChina),'omitnan');

% 朝鲜侧
humanDPRK = sum(human(validDPRK).*A(validDPRK),'omitnan') ...
          / sum(A(validDPRK),'omitnan');

climateDPRK = sum(climate(validDPRK).*A(validDPRK),'omitnan') ...
            / sum(A(validDPRK),'omitnan');

% 输出结果
fprintf('\n===== 中国侧农田 =====\n');
fprintf('人类活动相对贡献率：%.2f%%\n',humanChina);
fprintf('气候变化相对贡献率：%.2f%%\n',climateChina);
fprintf('贡献率之和：%.2f%%\n',humanChina+climateChina);

fprintf('\n===== 朝鲜侧农田 =====\n');
fprintf('人类活动相对贡献率：%.2f%%\n',humanDPRK);
fprintf('气候变化相对贡献率：%.2f%%\n',climateDPRK);
fprintf('贡献率之和：%.2f%%\n',humanDPRK+climateDPRK);




classNames = { ...
    '< -50%', ...
    '-50% to -10%', ...
    '-10% to 10%', ...
    '10% to 50%', ...
    '> 50%'};

%画图
figure('position',[50, 50, 2200, 480]);
subplot(1, 3, 1);
flag = ftxp_plane_4_syria(box,S,0.05,residualTrend);
 caxis([-0.1,0.1])

colormap(slanCM(97));
colorbar;
S3=shaperead('../data/shp/merge.shp');  %矢量数据
geoshow(S3, 'FaceColor', 'none', 'EdgeColor', 'k','LineWidth', 1.5);
text(0.05, 0.9, '(a)', 'Units', 'normalized', 'FontSize', 18, 'FontWeight', 'bold');


subplot(1, 3, 2);hold on;
% title('Human Activity');
human(~mask_crop)=nan;
flag = ftxp_plane_4_syria(box,S,0.05,humanClass);
S3=shaperead('../data/shp/merge.shp');  %矢量数据
geoshow(S3, 'FaceColor', 'none', 'EdgeColor', 'k','LineWidth', 1.5);
text(0.05, 0.9, '(b)', 'Units', 'normalized', 'FontSize', 18, 'FontWeight', 'bold');
colorbar;
colormap(gca,cmap);

% Colorbar
cb = colorbar;
cb.Ticks = 1:5;
cb.TickLabels = classNames;
cb.FontName = 'Times New Roman';
cb.FontSize = 12;
cb.FontWeight = 'normal';
cb.LineWidth = 0.5;


subplot(1, 3, 3);hold on;
% title('Climate Change');
climate(~mask_crop)=nan;
flag = ftxp_plane_4_syria(box,S,0.05,climateClass);

S3=shaperead('../data/shp/merge.shp');  %矢量数据
geoshow(S3, 'FaceColor', 'none', 'EdgeColor', 'k','LineWidth', 1.5);
text(0.05, 0.9, '(c)', 'Units', 'normalized', 'FontSize', 18, 'FontWeight', 'bold');

% Discrete color classification
colormap(gca,cmap);
clim([1 5]);


% Colorbar
cb = colorbar;
cb.Ticks = 1:5;
cb.TickLabels = classNames;
cb.FontName = 'Times New Roman';
cb.FontSize = 12;
cb.FontWeight = 'normal';
cb.LineWidth = 0.5;




exportgraphics(gcf, ...
    'C:\Users\Administrator\Desktop\投稿\6 JOURNAL OF APPLIED REMOTE SENSING\fig\7.tif', ...
    'Resolution',600);









% =========================================================
% 人类活动贡献率 & 气候变化贡献率分级图
% 需要变量：
% humanTrend, fittedTrend, mask_crop, box, S
% 若有国界/研究区边界 shp，也可继续叠加
% =========================================================

% 观测LAI趋势
obsTrend = humanTrend + fittedTrend;

% 初始化
humanRate   = nan(size(obsTrend));
climateRate = nan(size(obsTrend));

% 有效像元：农田内，且趋势有限，且分母不为0
valid = mask_crop ...
      & isfinite(obsTrend) ...
      & isfinite(humanTrend) ...
      & isfinite(fittedTrend) ...
      & abs(obsTrend) > 0;

% 贡献率（单位：%）
humanRate(valid)   = humanTrend(valid)   ./ obsTrend(valid) * 100;
climateRate(valid) = fittedTrend(valid)  ./ obsTrend(valid) * 100;

% =========================================================
% 分级
% 1 : < -50%
% 2 : -50% ~ -10%
% 3 : -10% ~ 10%
% 4 : 10% ~ 50%
% 5 : > 50%
% =========================================================
humanClass   = nan(size(humanRate));
climateClass = nan(size(climateRate));

% human
humanClass(humanRate < -50) = 1;
humanClass(humanRate >= -50 & humanRate < -10) = 2;
humanClass(humanRate >= -10 & humanRate <= 10) = 3;
humanClass(humanRate > 10 & humanRate <= 50) = 4;
humanClass(humanRate > 50) = 5;

% climate
climateClass(climateRate < -50) = 1;
climateClass(climateRate >= -50 & climateRate < -10) = 2;
climateClass(climateRate >= -10 & climateRate <= 10) = 3;
climateClass(climateRate > 10 & climateRate <= 50) = 4;
climateClass(climateRate > 50) = 5;

% 农田外不显示
humanClass(~mask_crop)   = NaN;
climateClass(~mask_crop) = NaN;

% =========================================================
% 颜色：负向 -> 弱 -> 正向
% =========================================================
cmap = [ ...
    140  81  10;   % 1 显著负向
    216 179 101;   % 2 负向
    245 245 245;   % 3 弱影响
     90 180 172;   % 4 正向
      1 102  94    % 5 显著正向
] / 255;




% 转成 single
A1 = single(residualTrend);
A2 = single(humanClass);
A3 = single(climateClass);

% 背景设为空白
A1(~mask) = NaN;
A2(~mask) = NaN;
A3(~mask) = NaN;

% 获取分辨率
dlon = median(abs(diff(lons1(1,:))),'omitnan');
dlat = median(abs(diff(lats1(:,1))),'omitnan');

% 像元中心坐标 -> 像元边界范围
lonlim = [min(lons1(:))-dlon/2, ...
          max(lons1(:))+dlon/2];

latlim = [min(lats1(:))-dlat/2, ...
          max(lats1(:))+dlat/2];

% 判断纬度方向
% 如果当前矩阵是南 -> 北，则翻转为北 -> 南
if lats1(1,1) < lats1(end,1)

    % A1 = flipud(A1);
    A2 = flipud(A2);
    A3 = flipud(A3);

end

% 建立地理参考
R = georefcells( ...
    latlim, ...
    lonlim, ...
    size(A2), ...
    'ColumnsStartFrom','north');

% 写出 GeoTIFF
geotiffwrite( ...
    'residualTrend.tif', ...
    A1, ...
    R, ...
    'CoordRefSysCode',4326);

geotiffwrite( ...
    'humanclass.tif', ...
    A2, ...
    R, ...
    'CoordRefSysCode',4326);

geotiffwrite( ...
    'climateclass.tif', ...
    A3, ...
    R, ...
    'CoordRefSysCode',4326);

disp('residualTrend.tif、human.tif 和 climate.tif 已保存');








% =========================================================
% 6 个数据转成 single
% =========================================================
A1 = single(nh4);
A2 = single(no3);
A3 = single(rice);
A4 = single(maize);
A5 = single(soybean);
A6 = single(irrigation);

% =========================================================
% 背景设为空白
% =========================================================
A1(~cropMask) = NaN;
A2(~cropMask) = NaN;
A3(~cropMask) = NaN;
A4(~cropMask) = NaN;
A5(~cropMask) = NaN;
A6(A6<0) = NaN;

% =========================================================
% 获取分辨率
% =========================================================
dlon = median(abs(diff(lons1(1,:))),'omitnan');
dlat = median(abs(diff(lats1(:,1))),'omitnan');

% 像元中心坐标 -> 像元边界范围
lonlim = [min(lons1(:))-dlon/2, ...
          max(lons1(:))+dlon/2];

latlim = [min(lats1(:))-dlat/2, ...
          max(lats1(:))+dlat/2];

% =========================================================
% 判断纬度方向
% 如果当前矩阵是南 -> 北，则翻转为北 -> 南
% =========================================================
if lats1(1,1) < lats1(end,1)

    % A1 = flipud(A1);
    % A2 = flipud(A2);
    % A3 = flipud(A3);
    % A4 = flipud(A4);
    % A5 = flipud(A5);
    A6 = flipud(A6);

end

% =========================================================
% 建立地理参考
% =========================================================
R = georefcells( ...
    latlim, ...
    lonlim, ...
    size(A6), ...
    'ColumnsStartFrom','north');

% =========================================================
% 写出 6 个 GeoTIFF
% =========================================================
geotiffwrite( ...
    'NH4_N.tif', ...
    A1, ...
    R, ...
    'CoordRefSysCode',4326);

geotiffwrite( ...
    'NO3_N.tif', ...
    A2, ...
    R, ...
    'CoordRefSysCode',4326);

geotiffwrite( ...
    'Rice_Nitrogen.tif', ...
    A3, ...
    R, ...
    'CoordRefSysCode',4326);

geotiffwrite( ...
    'Maize_Nitrogen.tif', ...
    A4, ...
    R, ...
    'CoordRefSysCode',4326);

geotiffwrite( ...
    'Soybean_Nitrogen.tif', ...
    A5, ...
    R, ...
    'CoordRefSysCode',4326);

geotiffwrite( ...
    'Irrigated_Cropland.tif', ...
    A6, ...
    R, ...
    'CoordRefSysCode',4326);

disp('6 个 GeoTIFF 已保存');







%% Figure 8: nitrogen and irrigation maps

[a1,R1] = readgeoraster('NH4_N.tif');
[a2,R2] = readgeoraster('NO3_N.tif');
[a3,R3] = readgeoraster('Rice_Nitrogen.tif');
[a4,R4] = readgeoraster('Maize_Nitrogen.tif');
[a5,R5] = readgeoraster('Soybean_Nitrogen.tif');
[a6,R6] = readgeoraster('I:\matlab\PLUE\data\N\irra.tif');

% a6 = imresize(a6,[720 720],'nearest');
% a6 = double(a6);


%分开画图
figure('position',[50, 50, 2000, 960]);
% -------- 子图1：空间分布 --------
subplot(2, 3, 1);
flag = ftxp_plane_4_syria(box, S, 0.05, a3);  % 绘制空间分布
colormap(gca, slanCM(10));                         % 为当前坐标轴设置 colormap
 % caxis([200000000,900000000]);         % 可选：自动适应数值范围
cb1 = colorbar;                                    % 创建 colorbar 对象
cb1.Title.String = 'kilograms';
cb1.Title.FontSize = 14;                           % 设置字体大小
cb1.Title.FontWeight = 'normal';   
% cb1.Title.Position = [-1, 298];
S3 = shaperead('../data/shp/merge.shp');
geoshow(S3, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 1.5);
% title('NH_4^ -N', 'Interpreter', 'tex');  % 使用 'tex' 解释器进行简单的文本格式化

text(0.05, 0.9, '(a)', 'Units', 'normalized', 'FontSize', 18, 'FontWeight', 'bold');


subplot(2, 3, 2);
flag = ftxp_plane_4_syria(box, S, 0.05, a4);  % 绘制空间分布
colormap(gca, slanCM(10));                         % 为当前坐标轴设置 colormap
% caxis([min(GPP_ann(:)), max(GPP_ann(:))]);         % 可选：自动适应数值范围

cb1 = colorbar;                                    % 创建 colorbar 对象
cb1.Title.String = 'kilograms';
cb1.Title.FontSize = 14;                           % 设置字体大小
cb1.Title.FontWeight = 'normal';   

S3 = shaperead('../data/shp/merge.shp');
geoshow(S3, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 1.5);
% title('GMIE');
text(0.05, 0.9, '(b)', 'Units', 'normalized', 'FontSize', 17, 'FontWeight', 'bold');


subplot(2, 3, 3);
flag = ftxp_plane_4_syria(box, S, 0.05, a5);  % 绘制空间分布
colormap(gca, slanCM(10));                         % 为当前坐标轴设置 colormap
  % caxis([20000000,120000000]);         % 可选：自动适应数值范围

cb1 = colorbar;                                    % 创建 colorbar 对象
cb1.Title.String = 'kilograms';
cb1.Title.FontSize = 14;                           % 设置字体大小
cb1.Title.FontWeight = 'normal';   
% cb1.Title.Position = [-1, 270];

S3 = shaperead('../data/shp/merge.shp');
geoshow(S3, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 1.5);
% title('NO_3^ -N', 'Interpreter', 'tex');  % 使用 'tex' 解释器进行简单的文本格式化
text(0.05, 0.9, '(c)', 'Units', 'normalized', 'FontSize', 18, 'FontWeight', 'bold');

subplot(2, 3, 4);
flag = ftxp_plane_4_syria(box, S, 0.05, a1);  % 绘制空间分布
colormap(gca, slanCM(10));                         % 为当前坐标轴设置 colormap
 % caxis([0,10]);
cb1 = colorbar;                                    % 创建 colorbar 对象
 % cb1.Title.String = 'kg N·ha^{-1} yr^{-1}';                   % 设置单位标签为标题
cb1.Title.String = 'g N·yr^{-1}';                   % 设置单位标签为标题
% cb1.Title.Position = [-1, 270];
S3 = shaperead('../data/shp/merge.shp');
geoshow(S3, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 1.5);
% title('Rice');
text(0.05, 0.9, '(d)', 'Units', 'normalized', 'FontSize', 17, 'FontWeight', 'bold');

subplot(2, 3, 5);
flag = ftxp_plane_4_syria(box, S, 0.05, a2);  % 绘制空间分布
colormap(gca, slanCM(10));                         % 为当前坐标轴设置 colormap
% caxis([min(GPP_ann(:)), max(GPP_ann(:))]);         % 可选：自动适应数值范围
 % caxis([0,120]);
cb1 = colorbar;                                    % 创建 colorbar 对象
 cb1.Title.String = 'g N·yr^{-1}';                   % 设置单位标签为标题

 % cb1.Title.Position = [-1, 270];

S3 = shaperead('../data/shp/merge.shp');
geoshow(S3, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 1.5);
% title('Maize');
text(0.05, 0.9, '(e)', 'Units', 'normalized', 'FontSize', 17, 'FontWeight', 'bold');

subplot(2, 3, 6);
a6(~mask_crop) = NaN;
flag = ftxp_plane_4_syria(box, S, 0.05, a6);  % 绘制空间分布
colormap(gca, slanCM(10));                         % 为当前坐标轴设置 colormap
% caxis([min(GPP_ann(:)), max(GPP_ann(:))]);         % 可选：自动适应数值范围
caxis([0,1]);
cb1 = colorbar;                                    % 创建 colorbar 对象
 % cb1.Title.String = 'kilograms';
 cb1.Title.Position = [0, 1];
S3 = shaperead('../data/shp/merge.shp');
geoshow(S3, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 1.5);
% title('Soybean');
text(0.05, 0.9, '(f)', 'Units', 'normalized', 'FontSize', 17, 'FontWeight', 'bold');


exportgraphics(gcf, ...
    'C:\Users\Administrator\Desktop\投稿\6 JOURNAL OF APPLIED REMOTE SENSING\fig\8.tif', ...
    'Resolution',600);





