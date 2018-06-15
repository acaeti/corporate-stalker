# corporate-stalker

A simple web service to serve avatar pictures for Cisco Jabber clients using Cisco User Data Service (UDS) as their directory service.  The pictures are pulled upon request from the Microsoft Active Directory "thumbnailphoto" attribute using LDAP, saving the administrator the trouble of periodically exporting them to static files.

The server running this web service must be referenced in jabber-config.xml for Cisco Unified Communications Manager (CUCM) releases prior to 12.5 or UC Services in CUCM 12.5+.  For example:

    <UdsPhotoUriWithToken>http://photos.contoso.com/%%uid%%.jpg</UdsPhotoUriWithToken>

If using Mobile and Remote Access (MRA), the picture server URL must also be added as a white listed HTTP URL in Cisco Expressway-C under Configuration > Unified Communications.

## Usage

Paparazzi uses a .env file to load settings to the app. A sample may be found in the file sample.env.

## Authors

* Nick Mueller, [CDW](http://www.cdw.com)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
