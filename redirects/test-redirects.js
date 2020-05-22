const https = require('https')
const fs = require('fs')

const baseUrl = 'https://adblockplus.org/redirect?link='
const redirectLinksString = fs.readFileSync('documentation-redirect-links.json')
const redirectLinks = JSON.parse(redirectLinksString)

redirectLinks.forEach((redirectLink) => {
    const sourceUrl = baseUrl + redirectLink.source
    checkUrlRedirect(sourceUrl, redirectLink.destination).then((responseString) => {
        console.log(`${redirectLink.source} ${responseString} \n`)
    }).catch((responseString) => {
        console.log(`${redirectLink.source} ${responseString} \n`)
    })
})

function checkUrlRedirect(source, destination) {
    return new Promise((resolve, reject) => {
        https.get(source, (response) => {
            if (response.statusCode !== 301 && response.statusCode !== 302) {
                reject(` FAILED \n-> Redirect failed at ${source} with response code: ${response.statusCode} \n-> Expected destination ${destination}`)
                return
            }
            if (response.headers.location !== destination) {
                resolve(checkUrlRedirect(response.headers.location, destination))
            } else {
                resolve(`PASSED`)
            } 
        })
    })
}
