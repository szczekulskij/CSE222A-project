import json
import matplotlib.pyplot as plt


def get_filename(algorithm_name, loss_rate, application_type):
    FOLDER_NAME = "../data"
    assert algorithm_name in ["BBR", "Cubic"], 'Algorithm name must be either "BBR" or "Cubic"'
    assert loss_rate in [0, 0.01, 0.005], 'Loss rate must be 0, 0.01, or 0.005'
    assert application_type in ["BulkTraffic", "WebApp"], 'Application type must be either "BulkTraffic" or "WebApp"'
    filename =  f'{algorithm_name}_{loss_rate}_{application_type}.json'
    return f'{FOLDER_NAME}/{filename}'


