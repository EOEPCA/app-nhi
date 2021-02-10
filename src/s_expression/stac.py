from pystac import Catalog, extensions
from urllib.parse import urlparse
import gdal


def get_item(catalog):

    cat = Catalog.from_file(catalog)

    try:

        collection = next(cat.get_children())
        item = next(collection.get_items())

    except StopIteration:

        item = next(cat.get_items())

    return item


def get_asset(item, band_name):

    asset = None
    asset_href = None

    eo_item = extensions.eo.EOItemExt(item)

    # Get bands
    if (eo_item.bands) is not None:

        for index, band in enumerate(eo_item.bands):
            print(band.common_name, band_name)
            if band.common_name in [band_name]:
                print(item.assets.keys())
                asset = item.assets[band.name.replace('-10m', '')]
                asset_href = fix_asset_href(asset.get_absolute_href())
                break

    return (asset, asset_href)


def fix_asset_href(uri):

    parsed = urlparse(uri)

    if parsed.scheme.startswith("http"):

        return "/vsicurl/{}".format(uri)

    elif parsed.scheme.startswith("file"):

        return uri.replace("file://", "")

    else:

        return uri
