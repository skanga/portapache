# portapache
A portable version of the world's best web server

## Introduction
Ever needed to share a folder over the network but could not get it to work? I had the same problem once too often. So I built PortApache?. It allows you to simply make any folder on your disk available to any other computer in their web browser.

Execute the program and it will prompt you for a port and a folder. That's it. Your folder and all sub folders beneath it are available to all other computers in their web browser.

## Security
Apache is probably the most tested web server on the planet. All the binaries used in PortApache? are directly taken from the version produced by the Apache Software Foundation. PortApache? simply provides the wrapper to configure and run the original binaries in a portable manner.

## Size
Plus, it's tiny - less than 1 MB - so it can easily be placed and run directly from your USB key.

## Usage
To run it simply unzip the zip file to any location you like. Then run `apache-start` script to run the server and `apache-stop` to stop it when you are done.

If you do not wish to be prompted then you can ener parameters on the command line as shown here:

`apache-start 80 c:\temp admin portapache` - Start the httpd on port `8080` and serve `c:\temp` with username `admin` and password `portapache`

The current version runs on Win 2K, XP, Vista, 2K3, etc. The Win 9x series is unsupported. Please contact me if you need a version that supports Linux/Unix

Caution: Please make sure you understand the security implications of doing this. Do not expose sensitive and private files under PortApache?. There are no warranties implied or otherwise on this software.

Note: This software is not affiliated in any way with the Apache Software Foundation.
