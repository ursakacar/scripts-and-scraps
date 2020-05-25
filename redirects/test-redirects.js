const https = require('https')
const http = require('http')
const fs = require('fs')

const baseUrl = 'https://adblockplus.org/redirect?link='
const redirectLinksString = fs.readFileSync('doc-redirect-links.json')
const redirectLinks = JSON.parse(redirectLinksString)

redirectLinks.forEach((redirectLink) => {
    let areRedirectsSuccessful = true
    const sourceUrl = baseUrl + redirectLink.source
    checkUrlRedirect(sourceUrl, redirectLink.destination).catch((responseString) => {
        console.log(`${redirectLink.source} ${responseString} \n`)
        areRedirectsSuccessful = false
    })

    return areRedirectsSuccessful ? 0 : 1
})

function checkUrlRedirect(source, destination) {
    return new Promise((resolve, reject) => {
        const protocol = (source.startsWith('https://') ? https : http)
        protocol.get(source, (response) => {
            if (response.statusCode > 300 && response.statusCode < 400) {
                const redirectLocation = getAbsoluteRedirectLocation(response.headers.location, source)
                resolve(checkUrlRedirect(redirectLocation, destination))
            } else {
                if ( source === destination && response.statusCode === 200) {
                    resolve(`PASSED`)
                } else {
                    reject(`FAILED \n-> Redirect failed at ${source} with response code: ${response.statusCode} \n-> Expected destination ${destination}`)
                }
            }
                
        })
    })
}

function getAbsoluteRedirectLocation(redirectLocation, source) {
    if (redirectLocation.startsWith('https://') || redirectLocation.startsWith('http://')) {
        return redirectLocation
    }

    const sourceUrl = new URL(source)
    const sourceProtocol = sourceUrl.protocol
    const sourceHostname = sourceUrl.hostname
    return `${sourceProtocol}//${sourceHostname}${redirectLocation}`
}