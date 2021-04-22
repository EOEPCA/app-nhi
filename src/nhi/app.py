import os
import sys
import logging
import click
from click2cwl import dump
import logging
from .s_expression import apply_s_expression
from .stac import get_item
from pystac import Item, Asset, MediaType, extensions, Catalog, CatalogType
from shapely.wkt import loads
from shapely.geometry import shape, mapping


logging.basicConfig(
    stream=sys.stderr,
    level=logging.DEBUG,
    format="%(asctime)s %(levelname)-8s %(message)s",
    datefmt="%Y-%m-%dT%H:%M:%S",
)

@click.command(
    short_help="nhi",
    help="Normalized Hot Spot Indices",
    context_settings=dict(
        ignore_unknown_options=True,
        allow_extra_args=True,
    ),
)
@click.option(
    "--input_reference", 
    "-i", 
    "input_reference", 
    help="Input product reference", 
    type=click.Path(), 
    required=True
)
@click.option(
    "--aoi", 
    "-a", 
    "aoi", 
    help="Area of interest in Well-known Text (WKT)", 
    required=False,
    default=None,
)
@click.pass_context
def main(ctx, input_reference, aoi):

    dump(ctx)
    
    item = get_item(os.path.join(input_reference, "catalog.json"))

    logging.info(f"Processing {item.id}")

    try:
        os.mkdir(item.id)
    except FileExistsError:
        pass

    item_out = Item(
        id=item.id,
        geometry=item.geometry if aoi is None else mapping(loads(aoi)),
        bbox=item.bbox if aoi is None else loads(aoi).bounds,
        datetime=item.datetime, 
        properties=item.properties,
        stac_extensions=item.stac_extensions,
    )

    eo_item = extensions.eo.EOItemExt(item_out)

    s_expressions = {}

    s_expressions["nhi1"] = "(/ (- swir22 swir16) (+ swir22 swir16))"
    s_expressions["nhi2"] = "(/ (- swir16 nir08) (+ swir16 nir08))"
    s_expressions["nhi1_bitmask"] = '(where (>= (/ (- swir22 swir16) (+ swir22 swir16)) 0.1) 1 0)'
    s_expressions["nhi2_bitmask"] = '(where (>= (/ (- swir16 nir08) (+ swir16 nir08)) 0.1) 1 0)'

    for cbn, s_expression in s_expressions.items():

        cbn = cbn.replace(' ', '-')    

        result = os.path.join(item.id, f"{cbn}.tif")

        logging.info(f"Apply {s_expression} to {item.id}")

        apply_s_expression(item=item, 
                        s_expression=s_expression, 
                        out_tif=result,
                        aoi=aoi)

        asset_properties = dict()

        asset_properties["s-expression"] = s_expression

        asset = Asset(
            href=os.path.basename(result),
            media_type=MediaType.COG,
            roles=["data"],
            properties=asset_properties,
        )

        eo_bands = [
            extensions.eo.Band.create(
                name=cbn.lower(),
                common_name=cbn.lower(),
                description=f"{cbn.lower()} ({s_expression})",
            )
        ]

        eo_item.set_bands(eo_bands, asset=asset)

        item_out.add_asset(key=cbn.lower(), asset=asset)

    logging.info("STAC")

    cat = Catalog(id="catalog", description="normalized hotspot indices")

    cat.add_items([item_out])

    cat.normalize_and_save(root_href="./", catalog_type=CatalogType.SELF_CONTAINED)

    logging.info("Done!")


if __name__ == "__main__":
    main()
