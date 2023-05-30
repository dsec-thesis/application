from typing import List

# import pygeohash as pgh


# def bboxes(min_lat, min_lon, max_lat, max_lon, number_of_chars):
#     if number_of_chars <= 0:
#         raise ValueError("number_of_chars must be strictly positive")
#     number_of_chars = number_of_chars or 9

#     hash_southwest = pgh.encode(min_lat, min_lon, precision=number_of_chars)
#     hash_northeast = pgh.encode(max_lat, max_lon, precision=number_of_chars)

#     lat_lon_sw = pgh.decode(hash_southwest)
#     lat_lon_ne = pgh.decode(hash_northeast)

#     per_lat = round((lat_lon_ne[0] - lat_lon_sw[0]) * 2, 5)
#     per_lon = round((lat_lon_ne[1] - lat_lon_sw[1]) * 2, 5)

#     box_southwest = pgh.decode_exactly(hash_southwest)
#     box_northeast = pgh.decode_exactly(hash_northeast)

#     lat_step = round((box_northeast[0] - box_southwest[0]) / per_lat)
#     lon_step = round((box_northeast[1] - box_southwest[1]) / per_lon)

#     hash_list = []

#     for lat in range(int(lat_step) + 1):
#         for lon in range(int(lon_step) + 1):
#             neighbor_hash = pgh.encode(
#                 lat_lon_sw[0] + lat * per_lat,
#                 lat_lon_sw[1] + lon * per_lon,
#                 precision=number_of_chars,
#             )
#             hash_list.append(neighbor_hash)

#     return hash_list


# lat = -32.943323
# lng = -60.6469889
# radio = 100

# geohash = pgh.encode(lat, lng, precision=9)

# lat_min, lon_min, lat_max, lon_max = pgh.decode_exactly(geohash)

# side_length = 2 * radio
# lat_min_square = lat_min - side_length
# lon_min_square = lon_min - side_length
# lat_max_square = lat_max + side_length
# lon_max_square = lon_max + side_length

# hashes = bboxes(lat_min_square, lon_min_square, lat_max_square, lon_max_square, 5)

# print(hashes)


def _parse_result_to_markdown(failure_messages: List[str]) -> str:
    message_to_commit = "### Failures Details: \n\n"

    for error in failure_messages:
        message_to_commit += "- " + error + "\n"

    return message_to_commit


failure = [
    "invocation: failed to start remote Kobold run",
    "Service1: fake-exception-msg-from-service1",
    "Service1 - cmp2: fake-exception-msg-from-cmp2",
]

commit = _parse_result_to_markdown(failure)

print(commit)
