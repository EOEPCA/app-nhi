# import gdal
# from collections import OrderedDict
# from .stac import get_asset
# from .s_expression import parse_expression


# def get_resolution(item, s_expression):

#     resolution = 10000
#     common_band_names = parse_expression(s_expression)

#     for index, common_name in enumerate(common_band_names):

#         _, asset_href = get_asset(item, common_name)

#         if not asset_href:

#             continue

#         _ds = gdal.Open(asset_href)

#         if resolution >= _ds.GetGeoTransform()[1]:

#             resolution = _ds.GetGeoTransform()[1]

#     return resolution


# def pre_process(item, s_expression):

#     assets = OrderedDict()

#     resolution = get_resolution(item, s_expression)

#     common_band_names = parse_expression(s_expression)

#     for index, common_name in enumerate(common_band_names):

#         _, asset_href = get_asset(item, common_name)

#         if not asset_href:

#             continue

#         _ds = gdal.Open(asset_href)

#         if _ds.GetGeoTransform()[1] == resolution:

#             assets[common_name] = asset_href

#         else:

#             gdal.Translate(
#                 "{}_{}.tif".format(common_name, resolution),
#                 _ds,
#                 xRes=resolution,
#                 yRes=resolution,
#             )

#             assets[common_name] = "{}_{}.tif".format(common_name, resolution)

#     return assets
