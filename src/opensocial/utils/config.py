import toml
import os

class ConfigError(Exception):
     """Configuration error for when a key is not found"""
     def __init__(self,key:str|None=None):
         if key == None:
             super().__init__("Unspecified config error")
         else:
             super().__init__(f"Error while getting config key: {key}")

def get(path:str, key:str="all"):
    '''
    Gets a key from a config file

    Parameters
    ----------
    path : str
        Path of the file
    key : str, optional
        Key to get, if set to all it gives all keys in a file (default is 'all')
    '''
    if not path.endswith(".toml"):
        return {}
    y = toml.loads(open(os.path.join("config/",path), 'r').read())

    if key == "all":
        return y
    else:
        try:
            return y[key]
        except KeyError:
            raise ConfigError(f"{path}:{key}")

def get_dir(path:str, key:str="all", ls: bool=False) -> list:
    '''
    Get all config files in a directory

    Parameters
    ----------
    path : str
        path of the folder
    key : str, optional
        key to get from all the files (default is 'all')
    ls : bool, optional
        Whether it should find files recursively (default is False)

    Returns
    -------
    list
        list of all files & keys
    '''
    tmp = []
    for i in os.listdir(os.path.join("config/",path)):
        if ls == False:
            if os.path.isdir(os.path.join("config/",path,i)):
                tmp.append({path+"/"+i: get_dir(os.path.join(path,i),key)})
            else:
                tmp.append({path+"/"+i: get(os.path.join(path,i),key)})
        else:
            tmp.append(get(os.path.join(path,i),key))
    return tmp
