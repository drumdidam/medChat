import { Resend } from 'resend';

export async function sendVerificationMail(email: string, token: string) {

	const config = useRuntimeConfig()
	const url = `${config.public.siteUrl}/auth/verify?token=${token}`

	console.log(email);

	const resend = new Resend(process.env.RESEND_API_KEY);

	const result = await resend.emails.send({
		from: 'noreply@dev.sernaglia.at',
		to: `${email}`,
		subject: 'Hello World',
		html: `
  <h2>Welcome to medChat</h2>
  <p>Please verfiy your Account by clicking this link</p>
  <a href="${url}">Verify NOW!</a>
  <p>Your link is valid for 24 hours</p>
  `
	});

	console.log('Resend result:', result);
}
