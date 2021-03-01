import './utils/public-path';

/**
 * Scripts to load just before `</body>`
 */
import {initCookieConsent} from "./relevance/relevance-cookie";
import "./nhsd-frontend/nhsd-frontend";

initCookieConsent();
